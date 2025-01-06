import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Accounts, (account) => account.transactions)
  @JoinColumn({ name: 'accountId' })
  account: Accounts;

  @Column()
  cantidad: number;

  @Column()
  tipo: 'ingreso' | 'gasto';

  @Column({ nullable: true })
  descripcion: string;
}
