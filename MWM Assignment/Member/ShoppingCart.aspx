<%@ Page Title="Shopping Cart Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ShoppingCart.aspx.cs" Inherits="MWM_Assignment.ShoppingCart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container">
        <div class="px-5 py-3 bg-white rounded shadow-sm mb-3">
            <div class="row justify-content-between mb-5">
                <div class="col ">
                    <h1 class="fw-bold mb-3">Your Cart</h1>
                </div>
            </div>

            <div class="align-items-center">
                <asp:DataList ID="dlCart" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%" OnItemCommand="dlCart_ItemCommand">
                    <HeaderTemplate>
                        <div class="border-0">
                            <div class="row align-items-center">
                                <div class="col-auto me-3" style="min-width: 184px;">
                                    <h5 class="fw-bold">Products</h5>
                                </div>
                                <div class="col">
                                    <div class="row">
                                        <div class="col-4 d-none d-md-flex">
                                        </div>
                                        <div class="col d-none d-lg-flex">
                                            <h5 class="fw-bold">Unit Price</h5>
                                        </div>
                                        <div class="col d-none d-md-flex">
                                            <h5 class="fw-bold">Quantity</h5>
                                        </div>
                                        <div class="col d-none d-md-flex">
                                            <h5 class="fw-bold">Subtotal</h5>
                                        </div>
                                        <div class="col d-none d-md-flex">
                                            <h5 class="fw-bold">Action</h5>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="border-0">
                            <div class="row align-items-center">
                                <div class="col-auto me-3">
                                    <asp:Image ID="Image1" runat="server" CssClass="img-fluid" ImageUrl='<%# Eval("image") %>' Style="height: 10rem; width: 10rem; object-fit: contain" />
                                </div>
                                <div class="col">
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md-4">
                                            <div class="mb-3">
                                                <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                                <asp:Label ID="Label2" runat="server" CssClass="h5" Text='<%# Eval("name") %>' />
                                            </div>
                                        </div>
                                        <div class="col d-none d-lg-flex">
                                            <asp:Label ID="Label5" runat="server" CssClass="text-secondary " Text='<%# Eval("price", "{0:C}") %>' />
                                        </div>
                                        <div class="col-12 col-md order-2 order-md-1">
                                            <div class="mb-1">
                                                <label class="text-secondary d-md-none">Qty: </label>
                                                <asp:TextBox ID="txtQty" runat="server" CssClass="form-control cart-textbox" TextMode="Number" Text='<%# Eval("qty") %>'></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md order-1 order-md-2 ">
                                            <div class="mb-1 justify-content-center">
                                                <label class="text-secondary d-md-none">Subtotal: </label>
                                                <asp:Label ID="Label4" runat="server" CssClass="text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md order-3">
                                            <div class="me-3 btn-group" role="group">
                                                <asp:LinkButton ID="LinkButton1" CssClass="btn btn-primary" runat="server" CommandName="update" CommandArgument='<%# Eval("pid") %>'><i class="bi bi-check-circle"></i></asp:LinkButton>
                                                <asp:LinkButton ID="LinkButton2" CssClass="btn btn-danger" runat="server" CommandName="delete" CommandArgument='<%# Eval("pid") %>'><i class="bi bi-trash"></i></asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr />
                    </ItemTemplate>
                    <FooterTemplate>
                        <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlCart.Items.Count != 0) ? "d-none" : ""%>">
                            <img src="~/Images/Placeholder/emptyCart.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                            <a href="../ProductCatalog.aspx">Your cart is empty! Click here to continue shopping!</a>
                        </div>
                    </FooterTemplate>
                </asp:DataList>
            </div>
        </div>

        <div class="px-5 py-3 bg-white rounded shadow-sm">
            <div class="row justify-content-end align-items-center">
                <div class="col col-md-auto me-5 mb-3 mb-md-0">
                    <asp:Label CssClass="h5 fw-bold me-3" runat="server" ID="lblItems" Text="" />
                    <asp:Label CssClass="h3 fw-bold text-danger" runat="server" ID="lblTotal" Text="" />
                </div>
                <div class="col-12 col-md-auto ">
                    <asp:Button CssClass="btn btn-primary px-5" runat="server" ID="btnCheckout" Text="Check Out" OnClick="btnCheckout_Click" />
                </div>
            </div>
        </div>


        <!-- Status Message -->
        <div runat="server" id="divStatus">
            <div class="position-fixed bottom-0 start-0 w-100">
                <div runat="server" id="statusBg" class="text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white">
                    <asp:Label runat="server" ID="lblStatusIcon" CssClass="bi-check-circle text-white h2" />
                    <asp:Label runat="server" ID="lblStatus" Text="" />
                </div>
            </div>
        </div>
        <!-- Status Message -->
    </main>
</asp:Content>
