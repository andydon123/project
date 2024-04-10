<?php
    


    $to = "groups@tyumenpdd.ru,".$email;
    
    $subject = "Ответы: ".$testName.", группа ".$number.", ".$name;

    $headers[] = 'MIME-Version: 1.0';
    $headers[] = 'Content-type: text/html; charset=iso-8859-1';
    

    

    $result = mail($to, $subject, $message, implode("\r\n", $headers));