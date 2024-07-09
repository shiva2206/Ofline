const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.resetShopViews = functions.region("asia-south1")
    .pubsub.schedule("every day 18:30")
    .timeZone("Asia/Kolkata")
    .onRun(async (context) => {
      const db = admin.firestore();
      const shopsRef = db.collection("Shop");

      try {
        const snapshot = await shopsRef.get();
        const batch = db.batch();

        snapshot.forEach((doc) => {
          const shopRef = shopsRef.doc(doc.id);
          batch.update(shopRef, {views: 0});
        });

        await batch.commit();
        console.log("All shop views reset to 0 successfully.");
      } catch (error) {
        console.error("Error resetting shop views:", error);
      }
    });
