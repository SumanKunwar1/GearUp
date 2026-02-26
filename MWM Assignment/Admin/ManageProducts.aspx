<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="MWM_Assignment.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mx-5 p-5">
        <div class="row">
            <div class="col">
                <h3 class="text-secondary">MANAGE PRODUCTS</h3>
            </div>
            <div class="col text-end">
                <asp:Button runat="server" ID="btnShowCreate" Text="Add New Product" CssClass="btn btn-primary" OnClick="btnShowCreate_Click" />
                <asp:Button runat="server" Visible="false" ID="btnCancel" Text="Cancel" CssClass="btn btn-danger" OnClick="btnCancel_Click" />
            </div>
        </div>
        <hr />
        <div runat="server" id="divProductDetails" visible="false">
            <div class="row my-5">
                <div class="col-12 col-md">
                    <h5 class="text-muted">PRODUCT IMAGE</h5>
                    <hr />
                    <div class="mb-3 position-relative">
                        <img id="productImage" runat="server" src="~/Images/Placeholder/placeholder.jpg" alt="Profile Image" class="category-image" clientidmode="Static" style="object-fit: contain" />
                        <asp:FileUpload runat="server" ID="fuImage" ClientIDMode="Static" CssClass="d-none" onchange="img();" />
                        <div class="d-flex justify-content-center align-items-center category-image-overlay" onclick="chooseFile()">
                            <i class="bi-pencil-square text-white"></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md">
                    <h5 class="text-muted">PRODUCT INFORMATION</h5>
                    <hr />
                    <div class="row g-0">
                        <!-- Name input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="John Doe" Style="min-width: 100%" />
                            <asp:Label runat="server" ID="lblName" AssociatedControlID="txtName" CssClass="form-label" Text="Name" />
                        </div>
                    </div>
                    <div class="row g-0">
                        <!-- Description input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="" Style="height: 8rem; min-width: 100%" />
                            <asp:Label runat="server" ID="lblDescription" AssociatedControlID="txtDescription" CssClass="form-label" Text="Description" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 col-md">
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text py-3">RM</div>
                                </div>
                                <!-- Price input -->
                                <div class="form-floating mb-3">
                                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" Style="min-width: 100%" />
                                    <asp:Label runat="server" ID="lblPrice" AssociatedControlID="txtPrice" CssClass="form-label" Text="Unit Price" />
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md">
                            <!-- Category input -->
                            <div class="form-floating mb-3">
                                <asp:DropDownList runat="server" ID="ddlCategory" CssClass="form-select mw-100" ToolTip="Category" AutoPostBack="true" />
                                <asp:Label runat="server" ID="lblCategory" AssociatedControlID="ddlCategory" CssClass="text-secondary" Text="Category" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row my-5">
                <div class="col text-center">
                    <asp:Button runat="server" Visible="false" ID="btnCreate" Text="Save Details" CssClass="btn btn-primary btn-lg" OnClick="btnCreate_Click" />
                    <asp:Button runat="server" Visible="false" ID="btnUpdate" Text="Update Details" CssClass="btn btn-primary btn-lg" OnClick="btnUpdate_Click" />
                </div>
            </div>
        </div>
        <div class="mb-5">
            <asp:ListView runat="server" ID="lvProduct" OnPagePropertiesChanging="lvProduct_PagePropertiesChanging" OnItemCommand="lvProduct_ItemCommand">
                <LayoutTemplate>
                    <table class="table table-hover table-responsive">
                        <thead>
                            <tr>
                                <th>No.</th>
                                <th>Name</th>
                                <th style="min-width: 400px;">Description</th>
                                <th style="min-width: 125px;">Unit Price</th>
                                <th style="min-width: 125px;">Category</th>
                                <th style="min-width: 125px;">Status</th>
                                <th style="min-width: 125px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="itemPlaceholder" runat="server"></tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" style="text-align: end">
                                    <asp:DataPager runat="server" ID="dpProduct" PagedControlID="lvProduct" PageSize="10">
                                        <Fields>
                                            <asp:NumericPagerField ButtonType="Button" CurrentPageLabelCssClass="btn btn-secondary" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Container.DataItemIndex + 1 %></td>
                        <td><%# Eval("prodName") %></td>
                        <td><%# Eval("description").ToString().Substring(0, Eval("description").ToString().Length > 150 ? 150 : Eval("description").ToString().Length) + (Eval("description").ToString().Length > 20 ? "..." : "") %></td>
                        <td><%# Eval("price", "{0:C}") %></td>
                        <td><%# Eval("catName") %></td>
                        <td><%# int.Parse(Eval("active").ToString()) == 1 ? "Active" : "Inactive" %></td>
                        <td>
                            <div class="row">
                                <div class="col-auto">
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn btn-primary" runat="server" CommandName="updateProduct" CommandArgument='<%# Eval("pid") %>'><i class="bi bi-pencil-square"></i></asp:LinkButton>
                                </div>
                                <div class="col-auto">
                                    <asp:LinkButton ID="LinkButton2" CssClass='btn btn-danger' runat="server" CommandName='<%# int.Parse(Eval("active").ToString()) == 1 ? "deleteProduct" : "restoreProduct" %>' CommandArgument='<%# Eval("pid") %>'><i class='bi <%# int.Parse(Eval("active").ToString()) == 1 ? "bi-trash" : "bi-arrow-counterclockwise" %>'></i></asp:LinkButton>
                                </div>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>
    <!-- Hidden Fields -->
    <div hidden>
        <asp:HiddenField runat="server" ID="hfUid" Value="" />
    </div>

    <!-- Status Message -->
    <div runat="server" id="divStatus" visible="false">
        <div class="position-fixed bottom-0 start-0 w-100" style="z-index: 100">
            <div runat="server" id="statusBg" class="text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white">
                <asp:Label runat="server" ID="lblStatusIcon" CssClass="bi-check-circle text-white h2" />
                <asp:Label runat="server" ID="lblStatus" Text="" />
            </div>
        </div>
    </div>
    <!-- Status Message -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
    <script type="text/javascript">

        function chooseFile() {
            document.getElementById("fuImage").click();
        }

        function img() {
            var url = inputToURL(document.getElementById("fuImage"));
            document.getElementById("productImage").src = url;
        }

        function inputToURL(inputElement) {
            var file = inputElement.files[0];
            return window.URL.createObjectURL(file);
        }

    </script>
</asp:Content>
