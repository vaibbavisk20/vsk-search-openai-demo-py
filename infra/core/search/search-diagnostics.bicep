param searchServiceName string = ''
param location string = resourceGroup().location

@description('Resource ID of log analytics workspace.')
param workspaceId string

@description('Optional. The name of logs that will be streamed.')
param logCategoriesToEnable array = ['OperationLogs']

@description('Optional. The name of metrics that will be streamed.')
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [
  for category in logCategoriesToEnable: {
    category: category
    enabled: true
  }
]

var diagnosticsMetrics = [
  for metric in metricsToEnable: {
    category: metric
    timeGrain: null
    enabled: true
  }
]

resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: searchServiceName
  location: location
  sku: {name: 'standard'} 
}

resource app_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${searchServiceName}-diagnostics'
  scope: searchService
  properties: {
    workspaceId: workspaceId
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
}
