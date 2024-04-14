use aiken/hash.{Blake2b_224, Hash}
use aiken/interval.{Finite}
use aiken/list
use aiken/time.{PosixTime}
use aiken/transaction.{ScriptContext, Transaction, ValidityRange}
use aiken/transaction/credential.{VerificationKey}

type ConditionsRedeemer {
    action: Action,
    deadline: PosixTime,
    owner: VerificationKeyHash,
    price: Int,
}


type Action {
    Owner
    Time
}


type VerificationKeyHash =
    Hash<Blake2b_224, VerificationKey>

validator {
    fn eaCoins(redeemer: ConditionsRedeemer, ctx: ScriptContext) -> Bool {
        when redeemer.action is {
            Owner -> must_be_signed_by(ctx.transaction, redeemer.owner)
            Time -> must_happen_before(ctx.transaction.validity_range, redeemer.deadline)
        }
    }
}

fn must_be_signed_by(transaction: Transaction, vk: VerificationKeyHash) {
    list.has(transaction.extra_signatories, vk)
}

fn must_happen_before(range: ValidityRange, lock_expiration_time: PosixTime) {
    when range.upper_bound.bound_type is {
        Finite(tx_latest_time) -> lock_expiration_time <= tx_latest_time
        _ -> False
    }
}
