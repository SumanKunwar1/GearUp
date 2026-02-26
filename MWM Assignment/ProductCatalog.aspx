<%@ Page Title="Product Catalog" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductCatalog.aspx.cs" Inherits="MWM_Assignment.ProductCatalog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container">
        <div class="row g-0">
            <div class="row g-0 my-3">
                <h3 class="text-secondary">PRODUCT CATALOG</h3>
                <hr />
            </div>
            <div class="row g-0 mb-3">
                <div class="col-auto">
                    <div class="form-floating me-3 py-1">
                        <asp:DropDownList runat="server" ID="ddlCategoryFilter" CssClass="form-select" ToolTip="Filter by Category" AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged" />
                        <asp:Label runat="server" ID="lblCategoryFilter" AssociatedControlID="ddlCategoryFilter" CssClass="text-secondary" Text="Category" />
                    </div>
                </div>
                <div class="col-auto">
                    <div class="form-floating me-3 py-1">
                        <asp:DropDownList runat="server" ID="ddlPriceFilter" CssClass="form-select" ToolTip="Filter by Category" AutoPostBack="true" OnSelectedIndexChanged="ddlPriceFilter_SelectedIndexChanged">
                            <asp:ListItem Value="-1">No Filter</asp:ListItem>
                            <asp:ListItem Value="0">Price: Low to High</asp:ListItem>
                            <asp:ListItem Value="1">Price: High to Low</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label runat="server" ID="lblPriceFilter" AssociatedControlID="ddlPriceFilter" CssClass="text-secondary" Text="Price" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <asp:ListView ID="ListView1" runat="server" OnItemCommand="ListView1_ItemCommand1">
                <ItemTemplate>
                    <div class="col-lg-3 col-md-6">
                        <div class="card p-1 my-2 shadow-sm">
                            <div class="row g-0">
                                <div class="col-6 col-md-12">
                                    <asp:Image ID="Image1" runat="server" CssClass="card-img" ImageUrl='<%# Eval("image") %>' Style="height: 200px; object-fit: contain" />
                                </div>
                                <div class="card-body col-6 col-md-12">
                                    <asp:Label ID="pidLabel" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                    <asp:Label ID="nameLabel" runat="server" CssClass="card-title" Text='<%# Eval("name") %>' />
                                    <br />
                                    <asp:Label ID="priceLabel" runat="server" CssClass="card-text text-danger" Text='<%# Eval("price", "{0:C}") %>' />
                                    <br />
                                    <asp:Button ID="Button1" runat="server" Text="Details" CssClass="btn btn-secondary mt-2" CommandName="showDetails" CommandArgument='<% # Eval("pid") %>' />
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="row justify-content-center align-content-center text-center">
                        <img src="~/Images/Placeholder/noData.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                        <label class="text-danger">No Products Found!</label>
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
        <asp:Label runat="server" ID="lblMessage" Text="" />


    </main>
</asp:Content>
