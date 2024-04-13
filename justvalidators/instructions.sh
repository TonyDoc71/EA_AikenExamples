## with customer types you need to writer your own auxilary functions for the validators 
## as aiken does not yet have a standard library

## use is to import modules or your own scripts
## _datum to ignore unused 

## Blake2b_224 for public key hashing
## Blake2b_256 for transaction ID
## https://aiken-lang.github.io/stdlib/aiken/hash.html
## https://github.com/aiken-lang/stdlib

## .ak files must all be in lower case, no cmael case or the compiler will ignore

## stay high level in aiken try to avoid using data unless you really need to
## define your own data types see typed_validators.ak


## typed_validators.ak

validator {
  fn typeddatum22(datum: Int, _redeemer: Data, _context: Data) -> Bool {
    datum == 22
  }
}

validator {
  fn typedRedeemer11(_datum: Data, redeemer: Int, _context: Data) -> Bool {
    redeemer == 11
  }
}

validator {
  fn datumVSredeemer(datum: Int, redeemer: Int, _context: Data) -> Bool {
    redeemer == datum
  }
}


// aux functions

type OurWonderfullDatum {
  owd: Int,
}

type OurWonderfullRedeemer {
  owr: Int,
}

validator {
  fn ourWonderfullValidator(
    datum: OurWonderfullDatum,redeemer: OurWonderfullRedeemer,_context: Data,) -> Bool {
    datum.owd == redeemer.owr
  }
}



## ------------------ Helper files ----------------------------------

bash repo$      alias aiken='/config/.aiken/bin/aiken'  -- making a shortcut to the path ## needs to be run every time you open a new terminal
alias aiken='/config/.aiken/bin/aiken'

bash repo/justvalidators$ aiken blueprint convert -m ..

 → alwayssucceedsalwaysfails.alwaysFails
        → alwayssucceedsalwaysfails.alwaysSucceeds
        → commonconditions.conditionator
        → toosimple_validators.datum22
        → toosimple_validators.datumVSredeemer
        → toosimple_validators.redeemer11
        → typed_validators.datumVSredeemer
        → typed_validators.ourWonderfullValidator  ## this is the one we used in the below
        → typed_validators.typedRedeemer11
        → typed_validators.typeddatum22


bash repo/justvalidators$ aiken blueprint convert -m typed_validators -v ourWonderfullValidator . > ./testnet/compiled/ourWonderfullValidator.uplc

Aiken blueprint --help

bash repo/justvalidators$ aiken blueprint address -m typed_validators -v ourWonderfullValidator . > ./testnet/outWonderfullValidator.addr

