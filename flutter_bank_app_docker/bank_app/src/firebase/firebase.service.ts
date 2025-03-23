import * as admin from 'firebase-admin';
import { Injectable, Logger } from '@nestjs/common';
import { config } from 'dotenv';
config();

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);

  constructor() {
    try {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.PROJECT_ID_FIREBASE,
          clientEmail: process.env.CLIENT_EMAIL_FIREBASE,
          privateKey: process.env.PRIVATE_KEY_FIREBASE?.replace(/\\n/g, '\n'),
        }),
      });
      console.log("Firebase inicializado correctamente");
    } catch (error) {
      console.error("Error inicializando Firebase:", error);
    }
    
  }

  async sendPushNotification(registrationToken: string, title: string, body: string) {
    try {
      console.log("Enviando notificación...");
      console.log("🔹 Token:", registrationToken);
      console.log("🔹 Título:", title);
      console.log("🔹 Cuerpo:", body);
  
      const notification = {
        token: registrationToken,
        notification: { title, body },
      };
    
      const response = await admin.messaging().send(notification);
  
      console.log("Notificación enviada con éxito:", response);
      this.logger.log(`Notificación enviada con éxito`);
  
      return response;
    } catch (error) {
      console.error("Error al enviar la notificación:", error);
      throw new Error(error);
    }
  }
  
}
