import { Body, Controller, Post } from "@nestjs/common";
import { FirebaseService } from "./firebase.service";


@Controller('notifications')
export class FirebaseController {
  constructor(private readonly notificationService: FirebaseService) {}
  @Post()
  async sendNotification(
    @Body() body: { token: string; notification: { title: string; body: string } }
  ) {
    try {
      if (!body.token || !body.notification?.title || !body.notification?.body) {
        return { message: 'Faltan datos en la petición', error: body };
      }
  
      const response = await this.notificationService.sendPushNotification(
        body.token,
        body.notification.title,
        body.notification.body
      );
  
      return { message: 'Notificación enviada', response };
    } catch (error) {
      return { message: 'Error al enviar la notificación', error: error.message };
    }
  }
  
}