{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Data.FileEmbed (embedFile)
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getPage3R :: Handler Html
getPage3R = do 
    defaultLayout $ do 
        $(whamletFile "templates/page3.hamlet")

getPage2R :: Handler Html
getPage2R = do 
    defaultLayout $ do 
        $(whamletFile "templates/page2.hamlet")
        toWidgetHead $(luciusFile "templates/page2.lucius")
        toWidgetHead $(juliusFile "templates/page2.julius")

getPage1R :: Handler Html
getPage1R = do 
    defaultLayout $ do 
        addScript (StaticR ola_js)
        [whamlet|
            <h1>
                PAGINA 1
            
            <div>
                <a href=@{HomeR}>
                    Voltar
        |]

getAdsR :: Handler TypedContent
getAdsR = return $ TypedContent "text/plain"
    $ toContent $(embedFile "static/ads.txt")

getHomeR :: Handler Html
getHomeR = do 
    sess <- lookupSession "_NOME"
    defaultLayout $ do 
        -- addScriptRemote "url" -> CHAMA JS EXTERNO
        -- addScript (StaticR script_js), ONDE script 
        -- eh o nome do seu script.
        -- pasta css, arquivo: bootstrap.css
        addStylesheet (StaticR css_bootstrap_css)
        
        toWidgetHead [julius|
            function ola(){
                alert("ola");
            }
        |]
        toWidgetHead [lucius|
            h1 {
                color : red;
            }
        |]
        [whamlet|
            <h1>
                OLA MUNDO!
            
            <ul>
                <li>
                    <a href=@{Page1R}>
                        PAGINA 1
                
                <li>
                    <a href=@{Page2R}>
                        PAGINA 2
                
                <li>
                    <a href=@{Page3R}>
                        PAGINA 3
                
                $maybe nome <- sess
                    <li>
                        Ola #{nome}
                    <form method=post action=@{SairR}>
                        <input type="submit" value="Sair">
                $nothing
                    <li>
                        Convidado!
                    <img src=@{StaticR pikachu_jpg}>
            
            <button class="btn btn-danger" onclick="ola()">
                OLA
        |]
