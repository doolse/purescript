module Main where

import Prelude
import Data.Record (class RowUnion, merge)
import Control.Monad.Eff.Console (log, CONSOLE)
import Control.Monad.Eff (Eff)

type Mand r = (title :: String | r)
type Opt eff = (onClick :: Unit -> Eff eff Unit)

defaultValues :: forall eff. {|Opt eff}
defaultValues = {onClick: \_ -> pure unit }

withDefaults :: forall o eff. RowUnion (Mand o) (Opt eff) (Mand (Opt eff)) => {|Mand o} -> {|Mand (Opt eff)}
withDefaults = merge defaultValues

main :: Eff (console::CONSOLE) Unit
main = do
  let withoutClick = withDefaults {title:"Title"}
      withClick = withDefaults {title:"Title", onClick: \_ -> log "Done"}
  withoutClick.onClick unit
  withClick.onClick unit
