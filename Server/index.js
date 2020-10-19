var express = require('express');
var app = express();
var nodemailer = require('nodemailer');

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

app.listen(3000, () => {
    console.log("Server running on port 3000");
});

app.get("/sendEmail", (req, res, next) => {
    console.log("Sending Email");
    res.json(["Hello", "World"]);

    // Should send email
    transporter.sendMail(mailOptions, function(err, info) {
        if (err) {
            console.log(err);
        } else {
            console.log(info);
        }
    })
});