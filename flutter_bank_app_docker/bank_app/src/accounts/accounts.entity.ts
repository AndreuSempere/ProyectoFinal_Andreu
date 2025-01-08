import { Credit_Card } from '../credit_cards/credit_card.entity';
import { Accounts_type } from '../account_type/account_type.entity';
import { User } from '../users/users.entity';
import { Transaction } from '../transactions/transactions.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  JoinColumn,
  ManyToOne,
  OneToMany,
  CreateDateColumn
} from 'typeorm';

@Entity()
export class Accounts {
  @PrimaryGeneratedColumn()
  id_cuenta: number;

  @Column({ type: 'bigint' })
  numero_cuenta: number;
  
  @Column({ unique: true })
  saldo: number;

  @Column()
  estado: string;

  @CreateDateColumn({ type: 'timestamp'})
  fecha_creacion: Date;

  @ManyToOne(
    () => Accounts_type,
    (accounts_type) => accounts_type.accounts,
    {
      nullable: false,
    },
  )
  @JoinColumn({ name: 'id_type' })
  accounts_type: Accounts_type;

  @ManyToOne(() => User, (id_user) => id_user.accounts)
  @JoinColumn({ name: 'id_user' })
  id_user: User;

  @OneToMany(() => Credit_Card, (credit_card) => credit_card.accounts)
  credit_card: Credit_Card[];

  @OneToMany(() => Transaction, (transactions) => transactions.account)
  transactions: Transaction[];

}
