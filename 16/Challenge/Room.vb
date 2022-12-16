Public Class Room
    Public Property FlowRate As Integer
    Public Property LeadsTo As String()

    Public Sub New(flowRate As Integer, leadsTo As String())
        Me.FlowRate = flowRate
        Me.LeadsTo = leadsTo
    End Sub
End Class