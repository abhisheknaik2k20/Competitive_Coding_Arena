importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");


firebase.initializeApp({
    apiKey: "AIzaSyBRwKFSOwufzarx7wOAiTb485273bFNmMg",
    authDomain: "leetcode-94c79.firebaseapp.com",
    projectId: "leetcode-94c79",
    storageBucket: "leetcode-94c79.firebasestorage.app",
    messagingSenderId: "702832973350",
    appId: "1:702832973350:web:20d095a1a2f61a28b478e7",
    measurementId: "G-02DBXD6D3C"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});