## Native Tokens in Aiken



----------------------------------------------------------------------------------------
####        problem with the conversion of bytestrings on local environment         ####
####        possible a windoes issue as xxd is a unix command                       ####
####        may need to get the path right on te bashrc file or manually install    ####

## solved 
bash repo$ apt-get update
bash repo$ apt-get install vim

bash repo$ whereis xxd
xxd: /usr/bin/xxd
----------------------------------------------------------------------------------------



## the spending of a UTXO is a specific and unique condition
## you can use this to make the tokens unique




## setting up a new workspace or project
## do not create directory aiken new will do it
repo$ aiken new createDirectory/projectname
##  this command will also create the directory, no need to do before hand
## will create all the files and directories  .lock .toml /validators /lib /build

repo$ cd newProjectDirectory
## create a new .ak file in the validators directory
## type in the script  (eacoins.ak) see below for script


## run these from the project folder not from the validators directory where the .ak script is
## aiken will find the script as it has the path. 
repo$ aiken ckeck
repo$ aiken build






## eacoins.ak     -- must be in lowercase or compiler will ignore

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




## created file after aiken build

## plutus.json

{
  "preamble": {
    "title": "validators/nativetokens",
    "description": "Aiken contracts for project 'validators/nativetokens'",
    "version": "0.0.0",
    "plutusVersion": "v2",
    "compiler": {
      "name": "Aiken",
      "version": "v1.0.26-alpha+075668b"
    },
    "license": "Apache-2.0"
  },
  "validators": [
    {
      "title": "eacoins.eaCoins",
      "redeemer": {
        "title": "redeemer",
        "schema": {
          "$ref": "#/definitions/eacoins~1ConditionsRedeemer"
        }
      },
      "compiledCode": "59015e0100003232323232322323225333005325333006300430073754600260106ea80144cc88c8cc004004dd618069807180718071807180718071807180718059baa00322533300d00114a0264a66601666e3cdd718078010020a51133003003001300f0013001300837540046eb8c028c02cc02cc020dd5002899199119299980519b8748008c02cdd5000899b89002375a601c60186ea8004528180218059baa3003300b37540046016601860186018601860186018601860126ea8c008c024dd50019bad30013009375400c4601660180024601400229309b2b2999801980098021baa00213232323232323232533300e3010002132498c94ccc030c02800454ccc03cc038dd50040a4c2c2a66601866e1d20020011533300f300e37540102930b0b18061baa00716375a601c002601c0046eb8c030004c030008dd698050009805001180400098029baa00216370e90002b9a5573aaae7955cfaba15745",
      "hash": "5fb50bbf42e9222d0423c0e320285745946eb244597df2de580eb0ea"
    }
  ],
  "definitions": {
    "ByteArray": {
      "dataType": "bytes"
    },
    "Int": {
      "dataType": "integer"
    },
    "eacoins/Action": {
      "title": "Action",
      "anyOf": [
        {
          "title": "Owner",
          "dataType": "constructor",
          "index": 0,
          "fields": []
        },
        {
          "title": "Time",
          "dataType": "constructor",
          "index": 1,
          "fields": []
        }
      ]
    },
    "eacoins/ConditionsRedeemer": {
      "title": "ConditionsRedeemer",
      "anyOf": [
        {
          "title": "ConditionsRedeemer",
          "dataType": "constructor",
          "index": 0,
          "fields": [
            {
              "title": "action",
              "$ref": "#/definitions/eacoins~1Action"
            },
            {
              "title": "deadline",
              "$ref": "#/definitions/Int"
            },
            {
              "title": "owner",
              "$ref": "#/definitions/ByteArray"
            },
            {
              "title": "price",
              "$ref": "#/definitions/Int"
            }
          ]
        }
      ]
    }
  }
}







## make a compiled directory

## create minting policy from script plutus.json
## look for the validators: Title


 "validators": [
    {
      "title": "eacoins.eaCoins",
      "redeemer": {
        "title": "redeemer",
        "schema": {
          "$ref": "#/definitions/eacoins~1ConditionsRedeemer"
        }
      },
      "compiledCode": "59015e0100003232323232322323225333005325333006300430073754600260106ea80144cc88c8cc004004dd618069807180718071807180718071807180718059baa00322533300d00114a0264a66601666e3cdd718078010020a51133003003001300f0013001300837540046eb8c028c02cc02cc020dd5002899199119299980519b8748008c02cdd5000899b89002375a601c60186ea8004528180218059baa3003300b37540046016601860186018601860186018601860126ea8c008c024dd50019bad30013009375400c4601660180024601400229309b2b2999801980098021baa00213232323232323232533300e3010002132498c94ccc030c02800454ccc03cc038dd50040a4c2c2a66601866e1d20020011533300f300e37540102930b0b18061baa00716375a601c002601c0046eb8c030004c030008dd698050009805001180400098029baa00216370e90002b9a5573aaae7955cfaba15745",
      "hash": "5fb50bbf42e9222d0423c0e320285745946eb244597df2de580eb0ea"
    }



repo$ aiken blueprint convert -m eacoins -v eaCoins . > ./Compiled/ak_eaCoins.uplc

## ak_eaCoins.uplc
{
  "type": "PlutusScriptV2",
  "description": "Generated by Aiken",
  "cborHex": "59016159015e0100003232323232322323225333005325333006300430073754600260106ea80144cc88c8cc004004dd618069807180718071807180718071807180718059baa00322533300d00114a0264a66601666e3cdd718078010020a51133003003001300f0013001300837540046eb8c028c02cc02cc020dd5002899199119299980519b8748008c02cdd5000899b89002375a601c60186ea8004528180218059baa3003300b37540046016601860186018601860186018601860126ea8c008c024dd50019bad30013009375400c4601660180024601400229309b2b2999801980098021baa00213232323232323232533300e3010002132498c94ccc030c02800454ccc03cc038dd50040a4c2c2a66601866e1d20020011533300f300e37540102930b0b18061baa00716375a601c002601c0046eb8c030004c030008dd698050009805001180400098029baa00216370e90002b9a5573aaae7955cfaba15745"
}





## create a policy ID from the plutus.json script

repo$ aiken blueprint policy -m eacoins -v eaCoins . > ./compiled/ak_eaCoins.pid

## ak_eaCoins.pid
5fb50bbf42e9222d0423c0e320285745946eb244597df2de580eb0ea










## make redeemer and datum for the script from the plutus.json file
## must be done manually as there isn't a tool yet

 "eacoins/ConditionsRedeemer": {
      "title": "ConditionsRedeemer",
      "anyOf": [
        {
          "title": "ConditionsRedeemer",
          "dataType": "constructor",
          "index": 0,
          "fields": [
            {
              "title": "action",
              "$ref": "#/definitions/eacoins~1Action"
            },
            {
              "title": "deadline",
              "$ref": "#/definitions/Int"
            },
            {
              "title": "owner",
              "$ref": "#/definitions/ByteArray"
            },
            {
              "title": "price",
              "$ref": "#/definitions/Int"
            }
          ]
        }
      ]

## create a redeemer.json file in the Values directory
## and use the below deom the minting policy to get the order
type ConditionsRedeemer {
    action: Action,
    deadline: PosixTime,
    owner: VerificationKeyHash,
    price: Int,
}

## order must be PosixTime, Owner, Price
## redeemer.json
{"constructor": 0, "fields":[{"constructor": 0, "fields":[]},{"int": 1713264078000},{"bytes": "a2a15a1901d0229101bcb31629629210ce8d2ccf058d05afea33e273"},{"int": 50}]}

## 1713264078000 is PosixTime 3 days in the future



## now you can create the minting transaction

## mint.sh


utxoin1="8f19c9ccc059ff129bed4d3276d96b15f77086474010ea826b280599b5563dbd#0"
utxoin2=""
policyid=$(cat ./Compiled/ak_eaCoins.pid)
nami="addr_test1qzwmwrahq43k0q5cktcv8dfh3ud9y3kr6udvp86heryd7w38rdzjclsf9svxrl67346q6a9uawvykesynl2d6cjt0plsuztp5u"
output="150000000"
tokenamount="100"
tokenname=$(echo -n "akeacoins" | xxd -ps | tr -d '\n')
collateral="4f507a7d6d5ed9a71b78e62b71372498d3379ffaf31e140e5d7c6c811ea03895#1"
signerPKH="a2a15a1901d0229101bcb31629629210ce8d2ccf058d05afea33e273"
ownerPKH=""
notneeded="--invalid-hereafter 46534111"
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $nami \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file ./Compiled/ak_eaCoins.uplc \
  --mint-redeemer-file ./Values/redeemer.json \
  --protocol-params-file protocol.params \
  --out-file mintTx.body

cardano-cli transaction sign \
    --tx-body-file mintTx.body \
    --signing-key-file ../../../WalletMine/5payment3.skey \
    --out-file mintTx.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file mintTx.signed


## in the minting script the UTXO, the Collateral and the owner are all from the same address so 
## only needed 1 public key hash and 1 signing key






repo$ cdmod +x mint.sh
repo$ ./mint.sh



https://preview.cexplorer.io/tx/c706abfb2cbc053eb313439b8196a02c63d6db9e50966f726649fed44b60ac5f
transaction link

