const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");

var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// Express 앱 생성
const app = express();

app.use(express.json()); // JSON 파싱 미들웨어

app.post("/createCustomToken", async (request, response) => {
    const user = request.body;

    const uid = `kakao: ${user.uid}`;
    const updateParams = {
        email: user.email,
        photoURL: user.photoURL,
        displayName: user.displayName,
    };

    try {
        await admin.auth().updateUser(uid, updateParams);
    } catch (error) {
        updateParams["uid"] = uid;
        await admin.auth().createUser(updateParams);
    }

    const token = await admin.auth().createCustomToken(uid);

    response.send(token);
});

// Firebase 함수로 Express 앱을 내보내기
exports.createCustomToken = functions.https.onRequest(app);
