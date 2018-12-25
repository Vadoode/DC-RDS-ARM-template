Configuration ITSwitchDC {

 param ( 
        $CountryName, $PsgrName
    )

    # this module contains the resources we're using.
    Import-DscResource -ModuleName PsDesiredStateConfiguration

     @('AD-Domain-Services', 'DNS', 'GPMC', 'RSAT-AD-Tools', 'RSAT-DNS-Server','RSAT-ADDS').ForEach({
             WindowsFeature $_
             {
                Name = $_
                Ensure = 'Present'
            }
         } 
      )
   

    File TestFile
    {
        Ensure = "Present"
        DestinationPath = "C:\TestFile"
        Contents = "Hello there $PsgrName! Welcome to $CountryName!"
    }
}


Configuration ITSwitchRDS {

    # this module contains the resources we're using.
    Import-DscResource -ModuleName PsDesiredStateConfiguration
  
   
     @('RDS-RD-Server', 'Remote-Desktop-Services', 'RSAT-RDS-Tools', 'RDS-Connection-Broker','RDS-Web-Access', 'RDS-Licensing').ForEach({
             WindowsFeature $_
             {
                Name = $_
                Ensure = 'Present'
            }
         } 
      )
   
    File TestFile
    {
        Ensure = "Present"
        DestinationPath = "C:\TestFile"
        Contents = "Hello there! Welcome to CountryName!"
    }
}





