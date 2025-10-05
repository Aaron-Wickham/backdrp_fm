// functions/src/index.ts
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import { initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

initializeApp();

setGlobalOptions({
  region: "us-central1",
  memory: "256MiB",   // v2 uses the "memory" string, not memoryMiB
  concurrency: 80,
});

const DEFAULT_TOPIC = "releases";

// Subscribe a single token to a topic (server-side for Web)
export const subscribeTokenToTopic = onCall(async (request) => {
  const token = String(request.data?.token ?? "").trim();
  const topic = String(request.data?.topic ?? DEFAULT_TOPIC).trim();
  if (!token) throw new HttpsError("invalid-argument", "Missing token");
  await getMessaging().subscribeToTopic(token, topic);
  return { ok: true, topic };
});

// Unsubscribe a single token from a topic
export const unsubscribeTokenFromTopic = onCall(async (request) => {
  const token = String(request.data?.token ?? "").trim();
  const topic = String(request.data?.topic ?? DEFAULT_TOPIC).trim();
  if (!token) throw new HttpsError("invalid-argument", "Missing token");
  await getMessaging().unsubscribeFromTopic(token, topic);
  return { ok: true, topic };
});

// ✅ Send a test push to the topic (Android + Web subscribers)
export const sendTestToTopic = onCall(async (request) => {
  const topic = String(request.data?.topic ?? DEFAULT_TOPIC).trim();
  await getMessaging().send({
    topic,
    notification: { title: "BACKDRP.FM Test", body: "Topic test notification" },
    data: { kind: "test", scope: "topic" },
  });
  return { ok: true, topic };
});

// ✅ Send a test push to a specific token (handy for Web)
export const sendTestToToken = onCall(async (request) => {
  const token = String(request.data?.token ?? "").trim();
  if (!token) throw new HttpsError("invalid-argument", "Missing token");
  await getMessaging().send({
    token,
    notification: { title: "BACKDRP.FM Test", body: "Direct token test" },
    data: { kind: "test", scope: "token" },
  });
  return { ok: true };
});
