<%@ Page Language="VB" AutoEventWireup="true" CodeFile="DuplicateValues.aspx.vb" Inherits="DuplicateValues" %>

<%@ Register Assembly="DevExpress.Web.v22.1, Version=22.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script>
        function OnBatchEditRowValidating(s, e) {
            for (var columnIndex in e.validationInfo) {
                var validationInfo = e.validationInfo[columnIndex];

                var column = s.GetColumn(columnIndex);
                if (s.cpUniqueColumnNames.indexOf(column.fieldName) > -1)
                    ValidateUniqueColumnValues(s, validationInfo, parseInt(columnIndex), e.key);
            }
        }

        function ValidateUniqueColumnValues(grid, validationInfo, columnIndex, rowKey) {
            var serverValue = grid.batchEditApi.GetCellValueByKey(rowKey, columnIndex, true);
            var oldClientValue = grid.batchEditApi.GetCellValueByKey(rowKey, columnIndex);
            var newClientValue = validationInfo.value;

            var isModifying = oldClientValue !== newClientValue;
            var wasModifiedBefore = serverValue !== oldClientValue;

            if (isModifying || wasModifiedBefore) {
                var uniqueValues = GetUniqueColumnValuesForValidation(grid, columnIndex, rowKey, isModifying);
                if (uniqueValues[newClientValue]) {
                    validationInfo.isValid = false;
                    validationInfo.errorText = "Duplicate value";
                }
            }
        }
        function GetUniqueColumnValuesForValidation(grid, columnIndex, editingRowKey, isModifying) {
            var clientChanges = grid.batchEditApi.GetUnsavedChanges();
            var uniqueValues = GetServerUniqueValues(grid)[columnIndex];

            for (var rowKey in clientChanges.deletedValues) {
                var columnValue = clientChanges.deletedValues[rowKey][columnIndex];
                delete uniqueValues[columnValue];
            }
            for (var rowKey in clientChanges.insertedValues) {
                var isSameRow = rowKey.toString() === editingRowKey.toString();

                if (isSameRow && !isModifying)
                    continue;
                
                var columnValue = clientChanges.insertedValues[rowKey][columnIndex];
                uniqueValues[columnValue] = true;
            }
            for (var rowKey in clientChanges.updatedValues) {
                var isSameRow = rowKey.toString() === editingRowKey.toString();

                if (isSameRow && !isModifying)
                    continue;

                var serverColumnValue = grid.batchEditApi.GetCellValueByKey(rowKey, columnIndex, true);
                var newColumnValue = clientChanges.updatedValues[rowKey][columnIndex];

                delete uniqueValues[serverColumnValue];
                uniqueValues[newColumnValue] = true;
            }

            return uniqueValues;
        }
        function GetServerUniqueValues(grid) {
            // Dict<int/columnIndex, Dict<object, bool>> - grid.cpValues.serverUniqueValues
            if (!grid.cpValues.serverUniqueValues) {
                var result = {};
                for (var columnIndex in grid.cpValues) {
                    var columnValuesHash = {};

                    var columnValues = grid.cpValues[columnIndex];
                    for (var i = 0; i < columnValues.length; i++) {
                        columnValuesHash[columnValues[i]] = true;
                    }
                    result[columnIndex] = columnValuesHash;
                }

                grid.cpValues.serverUniqueValues = result;
            }
            var values = grid.cpValues.serverUniqueValues;
            var clonedValues = JSON.parse(JSON.stringify(values));
            return clonedValues;
        }

    </script>
    
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxGridView ID="Grid" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" KeyFieldName="CategoryID" ClientInstanceName="grid" OnCustomJSProperties="Grid_CustomJSProperties" >
                <Columns>
                    <dx:GridViewCommandColumn ShowDeleteButton="true" ShowNewButton="true" />
                    <dx:GridViewDataTextColumn FieldName="CategoryID" ReadOnly="True" >
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="CategoryName" />
                    <dx:GridViewDataTextColumn FieldName="Description" />
                </Columns>
                <SettingsEditing Mode="Batch" />
                <ClientSideEvents BatchEditRowValidating="OnBatchEditRowValidating" />
                <SettingsPager PageSize="2" />
            </dx:ASPxGridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:NWindConnectionString %>" SelectCommand="SELECT [CategoryID], [CategoryName], [Description] FROM [Categories]" DeleteCommand="DELETE FROM [Categories] WHERE [CategoryID] = @CategoryID" InsertCommand="INSERT INTO [Categories] ([CategoryName], [Description]) VALUES (@CategoryName, @Description)" UpdateCommand="UPDATE [Categories] SET [CategoryName] = @CategoryName, [Description] = @Description WHERE [CategoryID] = @CategoryID">
                <DeleteParameters>
                    <asp:Parameter Name="CategoryID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="CategoryName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="CategoryName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="CategoryID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
