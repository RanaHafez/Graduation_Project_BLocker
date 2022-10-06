const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

export.sendNotification = functions.fireStore.document('usersData/{user}/toBorrowOrders/{order}').onCreate(
    async (snapshot, context) => {
    try{
       const notificationDocument = snapshot.data()
       const uid = context.params.user;

       const notificationBook = notificationDocument.bookRequested;
       const notificationPassword = notificationDocument.password;
       const userDoc = admin.fireStore().collection('usersData').doc(uid).get();
       const fcmToken = userDoc.data().fcmToken
       const message = {
          'notification': {
             title: notificationBook,
             body: notificationPassword,
          },
          token : fcmToken
       }

       return admin.messaging().send(message)
    }catch(error){
    }

})
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
