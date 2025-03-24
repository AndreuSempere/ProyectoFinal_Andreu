import * as admin from 'firebase-admin';
import { Injectable, Logger } from '@nestjs/common';
import { config } from 'dotenv';
config();

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);
  private bucket: any; 
  private initialized = false;

  constructor() {
    try {
      if (!process.env.STORAGE_BUCKET_FIREBASE) {
        this.logger.error('STORAGE_BUCKET_FIREBASE no está definido en las variables de entorno');
        console.error('STORAGE_BUCKET_FIREBASE no está definido en las variables de entorno');
        return; 
      }

      if (admin.apps.length === 0) {
        admin.initializeApp({
          credential: admin.credential.cert({
            projectId: process.env.PROJECT_ID_FIREBASE,
            clientEmail: process.env.CLIENT_EMAIL_FIREBASE,
            privateKey: process.env.PRIVATE_KEY_FIREBASE?.replace(/\\n/g, '\n'),
          }),
          storageBucket: process.env.STORAGE_BUCKET_FIREBASE
        });
      }
      
      const bucketName = process.env.STORAGE_BUCKET_FIREBASE;
      
      this.logger.log(`Intentando inicializar bucket: ${bucketName}`);
      console.log(`Intentando inicializar bucket: ${bucketName}`);
      
      this.bucket = admin.storage().bucket(bucketName);
      
      if (!this.bucket) {
        this.logger.error('No se pudo inicializar el bucket de Firebase');
        console.error('No se pudo inicializar el bucket de Firebase');
        return;
      }
      
      console.log("Firebase inicializado correctamente con bucket:", bucketName);
      this.logger.log(`Firebase inicializado correctamente con bucket: ${bucketName}`);
      this.initialized = true;
    } catch (error) {
      console.error("Error inicializando Firebase:", error);
      this.logger.error(`Error inicializando Firebase: ${error.message}`);
    }
    
  }

  isInitialized(): boolean {
    return this.initialized && !!this.bucket;
  }

  async sendPushNotification(registrationToken: string, title: string, body: string) {
    try {
      console.log("Enviando notificación...");
      console.log(" Token:", registrationToken);
      console.log(" Título:", title);
      console.log(" Cuerpo:", body);
  
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
  
  async uploadPdfToStorage(pdfBuffer: Buffer, userId: string, transactionId: string): Promise<string> {
    try {
      if (!this.bucket) {
        this.logger.error('El bucket de Firebase no está inicializado');
        throw new Error('El bucket de Firebase no está inicializado');
      }
      
      const fileName = `receipts/${userId}/${transactionId}.pdf`;
      const file = this.bucket.file(fileName);
      
      if (!file) {
        this.logger.error('No se pudo crear la referencia al archivo');
        throw new Error('No se pudo crear la referencia al archivo');
      }
      
      if (!pdfBuffer || !Buffer.isBuffer(pdfBuffer)) {
        this.logger.error('Buffer de PDF inválido');
        throw new Error('Buffer de PDF inválido');
      }
      
      await file.save(pdfBuffer, {
        metadata: {
          contentType: 'application/pdf',
        },
      });
      
      await file.makePublic();
      
      const publicUrl = `https://storage.googleapis.com/${this.bucket.name}/${fileName}`;
      
      this.logger.log(`PDF subido correctamente a Firebase Storage: ${publicUrl}`);
      return publicUrl;
    } catch (error) {
      this.logger.error(`Error al subir PDF a Firebase Storage: ${error.message}`);
      throw new Error(`Error al subir PDF a Firebase Storage: ${error.message}`);
    }
  }
}
