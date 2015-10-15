{-# LANGUAGE OverloadedStrings #-}
module Formalize.Formalizer
        ( pdfFromParams
        ) where

import           Data.Text          (Text)
import           Formalize.Types
import           Formalize.Util
import           Formalize.Validate

-- TODO: Simplify Left Right handling.
-- Try to create PDF file from params.
pdfFromParams :: [(Text,Text)] -> FilePath -> IO (Either FormData PDF)
pdfFromParams ps path =
    case formFromParams ps of
         Left x  -> do fd <- invalidInput x
                       return $ Left fd
         Right x -> do pdf <- validInput path x
                       return $ Right pdf


-- Create form data containing error message.
invalidInput :: (FormInput,Text) -> IO FormData
invalidInput (fi,msg) = createFormData fi $ FlashMessage msg

-- Create and save pdf.
validInput :: FilePath -> FormInput -> IO PDF
validInput path fi = do
    formData <- createFormData fi emptyFlash
    saveAsPdf formData path