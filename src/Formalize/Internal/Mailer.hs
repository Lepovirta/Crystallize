{-# LANGUAGE OverloadedStrings #-}
module Formalize.Internal.Mailer
    ( emailPDF
    ) where

import           Control.Monad        (when)
import qualified Data.ByteString.Lazy as LB
import           Data.Text            (Text)
import qualified Data.Text            as T
import qualified Data.Text.Lazy       as LT
import           Network.Mail.Mime
import           Network.Mail.SMTP (sendMailWithLogin')

import           Formalize.Types

-- Email PDF file to user using SMTP configurations. Return the given PDF.
emailPDF :: SMTPInfo -> Text -> PDF -> IO PDF
emailPDF smtp toEmail pdf = do
    let subject = "Kiteyttäjä"
        from    = Address Nothing (iSMTPFrom smtp)
        to      = Address Nothing toEmail
        mail    = addPdf pdf $ simpleMail' to from subject emailMessage
    when (hostExists smtp) $ sendEmail smtp mail
    return pdf

-- Add PDF attachment to Mail.
addPdf :: PDF -> Mail -> Mail
addPdf = addAttachmentBS "application/pdf" "Kiteyttaja.pdf" . LB.fromStrict


-- Send email using given STMP configuration.
sendEmail :: SMTPInfo -> Mail -> IO ()
sendEmail smtp =
    sendMailWithLogin'
        (T.unpack     $ iSMTPHost smtp)
        (fromIntegral $ iSMTPPort smtp)
        (T.unpack     $ iSMTPUser smtp)
        (T.unpack     $ iSMTPPAsswd smtp)

-- Check that host exists in STMP configuration. (Testing uses host = "")
hostExists :: SMTPInfo -> Bool
hostExists smtp = T.length (iSMTPHost smtp) > 0

-- Content of the email.
emailMessage :: LT.Text
emailMessage =
    "Moi!\n\
    \ \n\
    \Toivottavasti pelihetki oli antoisa - tässä Kiteyttäjä. Huomaat Kiteyttäjän visuaalisen kauneusleikkauksen etenemisen tässä matkan varrella.\n\
    \ \n\
    \Me uskomme palautteen voimaan. Haasta meidät palautteella niin tulet huomaamaan kehityksen seuraavaan pelisessioon mennessä.\n\
    \ \n\
    \Risut, ruusut ja pajut voi ohjata esimerkiksi johonkin seuraavista:\n\
    \ \n\
    \galla@galliwashere.com\n\
    \0400246626\n\
    \@jussigalla\n\
    \ \n\
    \innolla,\n\
    \gällit\n\
    \ \n\
    \Play. Focus. Do. Repeat\n"
