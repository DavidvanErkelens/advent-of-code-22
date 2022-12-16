Imports System

Module Program
    Sub Main(args As String())
        Dim test As IEnumerable = IO.File.ReadLines("../../../input/input.txt")
        Dim cave = New Cave()
            
        For Each line As String In test 
            cave.ParseRoomLine(line)
        Next
        
        cave.BuildDistanceMatrix()
        
        PartOne(cave)
        PartTwo(cave)
        
    End Sub

    Private Sub PartOne(cave As Cave)
        Dim paths = Cave.GetPathsForDistance(30)
        paths.Sort(function(path, path1) path.TotalScore.CompareTo(path1.TotalScore))

        Console.WriteLine("Part 1 | Path score: {0}", paths.Last().TotalScore)
    End Sub

    Private Sub PartTwo(cave As Cave)
        Dim paths = Cave.GetPathsForDistance(26)
        paths.Sort(function(path, path1) path1.TotalScore.CompareTo(path.TotalScore))
        Dim maxScore = 0
        Dim maxOpen = cave.NonZeroRooms().Count
        Console.WriteLine("Part 2 | Comparing paths... ({0} in total)         ", paths.Count)
        For Each myPath in paths
            If myPath.TotalScore < maxScore - paths.First().TotalScore
                Exit For
            End If
            For Each ePath in paths
                If myPath.Visited.Count + ePath.Visited.Count > maxOpen
                    Continue For
                End If
                If myPath.TotalScore + ePath.TotalScore < maxScore
                    Continue For
                End If
                If Not myPath.Visited.Intersect(ePath.Visited).Any()
                    maxScore = Math.Max(maxScore, myPath.TotalScore + ePath.TotalScore)
                    Exit For
                End If
            Next
        Next
        
        Console.WriteLine()
        Console.WriteLine("Part 2 | Maximum score: {0}", maxScore)
    End Sub
End Module
