import { Module } from '@nestjs/common';
import { UsersModule } from './users/users.module';
import { User } from './users/users.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { DataSource } from 'typeorm';
import { UtilsModule } from './utils/utils.module';
import { AccountsModule } from './accounts/accounts.module';
import { AccountTypeModule } from './account_type/account_type.module';
import { Accounts } from './accounts/accounts.entity';
import { Accounts_type } from './account_type/account_type.entity';


@Module({
  imports: [
    UsersModule,
    AccountsModule,
    AccountTypeModule,
    UtilsModule,
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
          Accounts_type
        ],
        synchronize: true,
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {
  constructor(private dataSource: DataSource) {}
}
