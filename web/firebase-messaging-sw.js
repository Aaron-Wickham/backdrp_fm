importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

// ⬇️ Paste your Web app config from Firebase Console → Project Settings → Your apps (Web)
firebase.initializeApp({
  apiKey: "AIzaSyCW2NDu5KORksksXoe2Py7In1uveo7JboM",
  authDomain: "backdrop-fm.firebaseapp.com",
  projectId: "backdrop-fm",
  storageBucket: "backdrop-fm.firebasestorage.app",
  messagingSenderId: "639126146221",
  appId: "1:639126146221:web:f5cb0d1b5cfdd8b5868a24",
  measurementId: "G-FVNDC15TC8",
});

// Initialize Messaging in the SW
const messaging = firebase.messaging();

// Optional: customize how notifications look when app is in the background:
self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  // Example: open your site or a video detail page
  event.waitUntil(clients.openWindow('/'));
});
