{-# LANGUAGE OverloadedStrings #-}
module Formalize.Html
    ( formHtml
    , pdfHtml
    ) where

import Control.Monad.IO.Class (MonadIO)
import Data.Text.Lazy as LT (Text)
import Formalize.Types
import System.FilePath
import Text.Hastache
import Text.Hastache.Context

-- Location of view files.
viewFolder :: FilePath
viewFolder = "web/view"

-- Render mustache template.
mustache :: MonadIO m => FilePath -> MuContext m -> m LT.Text
mustache file = hastacheFile defaultConfig path
    where path = viewFolder </> file

-- Empty context for 'static' views.
nullContext :: MonadIO m => MuContext m
nullContext = mkStrContext $ const $ MuVariable ("" :: LT.Text)

-- HTML for view containing the main form.
formHtml :: Maybe FlashMessage -> IO LT.Text
formHtml Nothing    = mustache "form.mustache" nullContext
formHtml (Just msg) = mustache "form.mustache" (mkGenericContext msg)

-- HTML for the PDF to render.
pdfHtml :: FormData -> IO LT.Text
pdfHtml = mustache "pdf.mustache" . mkGenericContext
