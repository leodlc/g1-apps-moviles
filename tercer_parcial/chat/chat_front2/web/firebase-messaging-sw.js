importScripts("https://www.gstatic.com/firebasejs/10.1.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.1.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCF-_Yht_xyMn4Bsc7AA17QyAPRO09DFuo",
  authDomain: "grupo1-4383c.firebaseapp.com",
  projectId: "grupo1-4383c",
  storageBucket: "grupo1-4383c.firebasestorage.app",
  messagingSenderId: "685439015147",
  appId: "1:685439015147:web:8de5d949d8443bb88506ae",
  measurementId: "G-Z19724PDDJ"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Notificación recibida en segundo plano:', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/icon-192x192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
