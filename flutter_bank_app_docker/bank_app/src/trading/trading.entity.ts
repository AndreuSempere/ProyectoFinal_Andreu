import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('trading_data')
export class TradingEntity {
  @PrimaryGeneratedColumn('increment', { name: 'idtrading' })
  idtrading: number;

  @Column()
  type: string;

  @Column()
  name: string;

  @Column()
  symbol: string;

  @Column('decimal', { precision: 10, scale: 2})
  price: number;

  @CreateDateColumn()
  recordedAt: Date;
}
