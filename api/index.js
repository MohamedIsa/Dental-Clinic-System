import { https } from 'firebase-functions';
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import sendEmail from './routes/email.js';

dotenv.config();
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());
app.post('/send-email', sendEmail);
console.log('Starting Firebase Function server...');
console.log('Exporting Firebase Function...');
export const api = https.onRequest(app);
