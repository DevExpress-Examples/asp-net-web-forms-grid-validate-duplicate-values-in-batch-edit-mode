﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class Category
	<System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")>
	Public Sub New()
		Me.Products = New HashSet(Of Product)()
	End Sub

	Public Property CategoryID() As Integer
	Public Property CategoryName() As String
	Public Property Description() As String
	Public Property Picture() As Byte()

	<System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")>
	Public Overridable Property Products() As ICollection(Of Product)
End Class

Partial Public Class Product
	Public Property ProductID() As Integer
	Public Property ProductName() As String
	Public Property SupplierID() As Integer?
	Public Property CategoryID() As Integer?
	Public Property QuantityPerUnit() As String
	Public Property UnitPrice() As Decimal?
	Public Property UnitsInStock() As Short?
	Public Property UnitsOnOrder() As Short?
	Public Property ReorderLevel() As Short?
	Public Property Discontinued() As Boolean
	Public Property EAN13() As String

	Public Overridable Property Category() As Category
End Class
