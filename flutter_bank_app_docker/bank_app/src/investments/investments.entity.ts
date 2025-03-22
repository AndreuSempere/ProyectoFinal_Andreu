import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { TradingEntity } from '../trading/trading.entity';

@Entity('investments')
export class Investment {
  @PrimaryGeneratedColumn()
  idInvestment: number;

  @ManyToOne(() => Accounts, (account) => account.investments)
  @JoinColumn({ name: 'account_id' })
  account: Accounts;

  @ManyToOne(() => TradingEntity)
  @JoinColumn({ name: 'trading_id' })
  trading: TradingEntity;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column('decimal', { precision: 10, scale: 2 })
  purchase_price: number;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  current_value: number;

  @CreateDateColumn()
  purchase_date: Date;

  @Column({ nullable: true })
  last_updated: Date;
}
