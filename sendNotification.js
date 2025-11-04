import { GoogleAuth } from 'google-auth-library';
import fetch from 'node-fetch';

const serviceAccountPath = './service-account.json';

const projectId = 'mediconsult-b8437';

const deviceToken = 'cQ4zKK2VTpudGm6u7Q-uxA:APA91bGn46aSZIH3BO4lkPDET8vWZesN34A5iSYuDQ5PC_H2-266v7LWHuY1w8GKO7yeqQHYNrg60nxnKhkhtqjxQYraQ2JBKrawaSmR0ctSy_FsQnS0vdI';

async function sendFCMMessage() {
    try {
        const auth = new GoogleAuth({
            keyFile: serviceAccountPath,
            scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
        });
        const accessToken = await auth.getAccessToken();

        const url = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

        const message = {
            message: {
                token: deviceToken,
                notification: {
                    title: 'Special Offer 🎉',
                    body: 'Save 20% on your next visit!',
                },
                data: {
                    image: 'https://www.future-doctor.de/wp-content/uploads/2024/08/shutterstock_2480850611.jpg',
                    largeIcon: 'https://upload.wikimedia.org/wikipedia/commons/4/4f/Iconic_logo.png',
                    forceBigPicture: 'true',
                    color: '#1E88E5',
                    group: 'promos',
                    channel: 'promotions',
                    type: 'approval',
                    id: '123',
                },
                android: {
                    priority: 'high',
                },
            },
        };

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(message),
        });

        const result = await response.json();
        console.log('✅ Response:', result);
    } catch (error) {
        console.error('❌ Error sending message:', error);
    }
}

sendFCMMessage();
