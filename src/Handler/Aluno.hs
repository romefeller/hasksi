{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Aluno where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql

formAluno :: Form Aluno 
formAluno = renderBootstrap $ Aluno 
    <$> areq textField "Nome: " Nothing 
    <*> areq textField "RA: "   Nothing 
    <*> areq dayField  "Data: " Nothing 

getAlunoR :: Handler Html 
getAlunoR = do 
    (widget, enctype) <- generateFormPost formAluno 
    msg <- getMessage
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE ALUNO
            
            <form method=post action=@{AlunoR}>
                ^{widget}
                <button>
                    Cadastrar
        |]

postAlunoR :: Handler Html 
postAlunoR = do 
    ((result,_),_) <- runFormPost formAluno 
    case result of 
        FormSuccess aluno -> do 
            runDB $ insert aluno 
            setMessage [shamlet|
                <h2>
                    REGISTRO INCLUIDO
            |]
            redirect AlunoR
        _ -> redirect HomeR


