bash repo$      alias aiken='/config/.aiken/bin/aiken'  -- making a shortcut to the path ## needs to be run every time you open a new terminal
alias aiken='/config/.aiken/bin/aiken'

bash repo/justvalidators$ aiken blueprint convert -m ..

 → alwayssucceedsalwaysfails.alwaysSucceeds
        → commonconditions.conditionator
        → toosimple_validators.datum22
        → toosimple_validators.datumVSredeemer
        → toosimple_validators.redeemer11
        → typed_validators.datumVSredeemer
        → typed_validators.ourWonderfullValidator  ## this is the one we used below
        → typed_validators.typedRedeemer11
        → typed_validators.typeddatum22

## to save to a file
bash repo$ aiken blueprint convert -m typed_validators -v ourWonderfullValidator . > ./testnet/compiled/ourWonderfullValidator.uplc

## to display to terminal
bash repo$ aiken blueprint convert -m typed_validators -v ourWonderfullValidator .

Aiken blueprint --help

bash repo$ aiken blueprint address -m typed_validators -v ourWonderfullValidator . > ./testnet/ourWonderfullValidator.addr