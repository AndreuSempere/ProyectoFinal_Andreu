import { UnauthorizedException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { Injectable, NestMiddleware } from '@nestjs/common';
import { AuthService } from './Autentication/auth.service';

@Injectable()
export class AuthorizationMiddleware implements NestMiddleware {
  constructor(private readonly authService: AuthService) {}

  async use(req: Request, res: Response, next: NextFunction) {
    if (process.env.ENABLE_TOKEN_VALIDATION === 'true') {
      const authHeader = req.headers['authorization'];

      if (!authHeader) {
        throw new UnauthorizedException('Token no encontrado');
      }

      // Extraer el token del encabezado de autorización (Bearer token)
      const token = authHeader.split(' ')[1];
      if (!token) {
        throw new UnauthorizedException('Formato de token inválido');
      }

      const isValid = await this.authService.validateToken(token);
      if (!isValid) {
        throw new UnauthorizedException('Token inválido o expirado');
      }
    }
    next();
  }
}