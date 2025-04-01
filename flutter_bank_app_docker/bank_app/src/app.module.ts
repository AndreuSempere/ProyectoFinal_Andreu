import {
  MiddlewareConsumer,
  Module,
  NestModule,
  RequestMethod,
} from '@nestjs/common';
import { UsersModule } from './users/users.module';
import { User } from './users/users.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { UtilsModule } from './utils/utils.module';
import { AccountsModule } from './accounts/accounts.module';
import { AccountTypeModule } from './account_type/account_type.module';
import { Accounts } from './accounts/accounts.entity';
import { Accounts_type } from './account_type/account_type.entity';
import { Credit_Card } from './credit_cards/credit_card.entity';
import { Credit_CardModule } from './credit_cards/credit_card.module';
import { TransactionsModule } from './transactions/transactions.module';
import { Transaction } from './transactions/transactions.entity';
import { FirebaseModule } from './firebase/firebase.module';
import { TradingEntity } from './trading/trading.entity';
import { TradingModule } from './trading/trading.module';
import { Investment } from './investments/investments.entity';
import { InvestmentsModule } from './investments/investments.module';
import { AuthorizationMiddleware } from './authorization.middleware';
import { AuthService } from './Autentication/auth.service';

@Module({
  imports: [
    UsersModule,
    AccountsModule,
    AccountTypeModule,
    Credit_CardModule,
    TransactionsModule,
    TradingModule,
    InvestmentsModule,
    UtilsModule,
    FirebaseModule,
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forFeature([User]),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'mysql',
        host: 'database',
        port: +configService.get('MYSQL_PORT') || 3306,
        username: configService.get('MYSQL_USER'),
        password: configService.get('MYSQL_PASSWORD'),
        database: configService.get('MYSQL_DATABASE'),
        entities: [
          User,
          Accounts,
          Accounts_type,
          Credit_Card,
          Transaction,
          TradingEntity,
          Investment,
        ],
        synchronize: true,
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [],
  providers: [AuthorizationMiddleware, AuthService],
})
export class AppModule implements NestModule {
  // Se protegen todas las rutas excepto las de login y el registro de usuarios
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(AuthorizationMiddleware)
      .exclude(
        { path: 'users/login', method: RequestMethod.POST },
        { path: 'users', method: RequestMethod.POST },
      )
      .forRoutes('*');
  }
}
