import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id_transaction: number;

  @Column()
  cantidad: number;

  @Column()
  tipo: 'ingreso' | 'gasto';

  @Column({ nullable: true })
  descripcion: string;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @ManyToOne(() => Accounts, (account) => account.transactions, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'accountId' })
  account: Accounts;
}
