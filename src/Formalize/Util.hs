module Formalize.Util
    ( saveAsPdf
    , createFormData
    ) where

import qualified Data.ByteString     as BS
import qualified Data.Text           as T
import           Data.Time.Format
import           Data.Time.LocalTime
import           Formalize.Pdf
import           Formalize.Types
import           System.FilePath

-- Create timestamp for filename.
timestamp :: String -> IO FilePath
timestamp format = fmap (formatTime defaultTimeLocale format) getZonedTime

-- Generate filename.
filename :: FilePath -> FilePath -> FilePath
filename path ts = path </> ts <.> "pdf"

-- Save form data as PDF.
saveAsPdf :: FormData -> FilePath -> IO PDF
saveAsPdf fd path = do
    let ts = fdFileTimestamp fd
    file <- createPDF fd
    BS.writeFile (filename path ts) file
    return file

-- Construct form data from input, flash message and timestamp.
createFormData :: FormInput -> FlashMessage -> IO FormData
createFormData fi fm = do
    fileTs <- timestamp "%Y%m%d-%H:%M:%S"
    humanTs <- T.pack <$> timestamp "%d.%m.%Y"
    return $ FormData fi fm fileTs humanTs
