param skuName string = 'D1'
param skuCapacity int = 1
param location string = resourceGroup().location
param appBaseName string = resourceGroup().name
param appName string = toLower('kk${appBaseName}')

var appServicePlanName = toLower('asp-${appName}')
var webSiteName = toLower('${appName}web')
  
resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName // app serivce plan name
  location: location // Azure Region
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: {
    displayName: 'plan'
    ProjectName: appName
  } 
}

resource appService  'Microsoft.Web/sites@2021-01-15' = {
  name: webSiteName // Globally unique app serivce name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    ProjectName: appName
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: false
    siteConfig: {
      minTlsVersion: '1.2'
      netFrameworkVersion:'v5.0'
      defaultDocuments:[
        'Default.htm'
        'Default.html'
        'index.htm'
        'index.html'
        'iisstart.htm'
        'default.aspx'
        'hostingstart.html'
      ]
    }
  }
}
