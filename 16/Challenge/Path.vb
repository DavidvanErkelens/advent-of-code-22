Public Class Path
    Public Property AtNode As String
    Public Property Visited As List(Of String)
    Public Property StillToVisit As List(Of String)
    Public Property MinutesSpent As Integer
    Public Property TotalScore As Integer

    Public Sub New(atNode As String, visited As List(Of String), stillToVisit As List(Of String), minutesSpent As Integer, totalScore As Integer)
        Me.AtNode = atNode
        Me.Visited = visited
        Me.StillToVisit = stillToVisit
        Me.MinutesSpent = minutesSpent
        Me.TotalScore = totalScore
    End Sub

    Public Function FollowUpPaths(cave As Cave, maxMinutes As Integer) As List(Of Path)
        Dim nextPaths = new List(Of Path)

        For Each nextNode In StillToVisit
            Dim nextMinuteCount = MinutesSpent + cave.Distances(AtNode)(nextNode) + 1
            
            If nextMinuteCount > maxMinutes
                Continue For
            End If
            
            Dim toVisit = new List(Of String)(StillToVisit)
            toVisit.Remove(nextNode)
            
            Dim alreadyVisited = new List(Of String)(Visited)
            alreadyVisited.Add(nextNode)
            
            Dim newScore = TotalScore + (cave.Rooms.Item(nextNode).FlowRate * (maxMinutes - nextMinuteCount))
            nextPaths.Add(new Path(nextNode, alreadyVisited, toVisit, nextMinuteCount, newScore))
        Next
        
        return nextPaths
    End Function
End Class