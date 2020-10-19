import * as functions from 'firebase-functions';
const nodemailer = require('nodemailer');


// Logging into Email
var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: '408rfleet@gmail.com',
        pass: 'electricbike'

    }
});

// Email Configuration
const mailOptions = {
    from: "Fabrizio@Papi.com",
    to: 'tamerbader01@gmail.com',
    subject: 'A Special Email From Italy',
    html: '<p>We have your location :) </p>'
};


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


export const sendNotification = functions.https.onRequest((request, response) => {
    console.log("Sending Email")
    sendMail().then(() => {
        response.status(200).send(true);
    })

})

export const registerUser = functions.https.onRequest((request, response) => {
    console.log("Creating New User");
    admin.auth().createUserWithEmailAndPassword("tamerbader01@gmail.com", "tamer123").then(() => {
        response.status(200).send(true);
    }).catch(function(error: string) {
        console.log(error);
        response.status(400).send(false);
    })
})
    

// Send email function
function sendMail() {
    return transporter.sendMail(mailOptions);
  }