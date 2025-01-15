import { createTransport } from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = createTransport({
    secure: true,
    host: 'smtp.gmail.com',
    port: 465,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});


const sendEmail = async (req, res) => {
    console.log('Incoming request to /send-email');
    console.log('Request body:', req.body);

    const { recipientEmail, subject, message } = req.body;

    if (!recipientEmail || !subject || !message) {
        console.error('Validation Error: Missing required fields');
        return res.status(400).send("Missing required fields: 'recipientEmail', 'subject', or 'message'");
    }

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: recipientEmail,
        subject: subject,
        text: message,
    };

    console.log('Mail options:', mailOptions);

    try {
        console.log('Attempting to send email...');
        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent successfully:', info.response);
        res.status(200).send('Email sent successfully');
    } catch (error) {
        console.error('Error sending email:', error);
        res.status(500).send('Error sending email: ' + error.message);
    }
};

export default sendEmail;
