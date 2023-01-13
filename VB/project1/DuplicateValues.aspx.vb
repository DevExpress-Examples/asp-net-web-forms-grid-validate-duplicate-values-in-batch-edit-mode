Imports DevExpress.Web
Imports System
Imports System.Collections.Generic
Imports System.Linq

Partial Public Class DuplicateValues
	Inherits System.Web.UI.Page

	Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)

	End Sub

	Protected Sub Grid_CustomJSProperties(ByVal sender As Object, ByVal e As ASPxGridViewClientJSPropertiesEventArgs)
		Dim columnNamesThatShouldHaveUniqueValues = { "CategoryName", "Description" }

		Dim editColumns = Grid.DataColumns.Where(Function(c) columnNamesThatShouldHaveUniqueValues.Contains(c.FieldName))
		Dim uniqueValues = New Dictionary(Of Integer, Object())()
		For Each column In editColumns
			Dim columnValues = New List(Of Object)()
			For visibleIndex As Integer = 0 To Grid.VisibleRowCount - 1
				If Not Grid.IsGroupRow(visibleIndex) Then
					columnValues.Add(Grid.GetRowValues(visibleIndex, column.FieldName))
				End If
			Next visibleIndex
			If columnValues.Count <> columnValues.Distinct().Count() Then
				Throw New Exception("The duplicate value found")
			End If

			uniqueValues(column.Index) = columnValues.ToArray()
		Next column
		e.Properties("cpValues") = uniqueValues
		e.Properties("cpUniqueColumnNames") = editColumns.Select(Function(c) c.FieldName).ToArray()
	End Sub
End Class



