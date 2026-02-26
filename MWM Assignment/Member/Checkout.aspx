<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="MWM_Assignment.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container">

        <div class="px-5 py-3 bg-white rounded shadow-sm">

            <div class="row mb-5">
                <h1 class="fw-bold mb-3">Checkout</h1>
            </div>

            <div class="align-items-center">
                <asp:DataList ID="dlCart" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
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
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr />
                    </HeaderTemplate>
                    <ItemTemplate>
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
                                        <asp:Label ID="Label5" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                    </div>
                                    <div class="col-12 col-md order-2 order-md-1">
                                        <div class="mb-1">
                                            <label class="text-secondary d-md-none">Qty: </label>
                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("qty") %>' />
                                        </div>
                                    </div>
                                    <div class="col-12 col-md order-1 order-md-2">
                                        <div class="mb-1">
                                            <label class="text-secondary d-md-none">Subtotal: </label>
                                            <asp:Label ID="Label4" runat="server" CssClass="text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr />
                    </ItemTemplate>
                </asp:DataList>
            </div>
        </div>
        <div class="px-5 py-3 bg-white rounded shadow-sm">
            <div class="row">
                <div class="col-md-8">
                </div>
                <div class="col col-md-4 text-end">
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="text-secondary">Merchandise Total:</th>
                                <th>
                                    <asp:Label CssClass="text-secondary" runat="server" ID="lblTotal" Text="" /></th>
                            </tr>
                            <tr>
                                <th class="text-secondary">SST (10%):</th>
                                <th>
                                    <asp:Label CssClass="text-secondary" runat="server" ID="lblTax" Text="" />
                                </th>
                            </tr>
                            <tr>
                                <th class="text-secondary">Grand Sub-Total:</th>
                                <th>
                                    <asp:Label CssClass="h3 fw-bold text-danger" runat="server" ID="lblSubtotal" Text="" />
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <asp:Button runat="server" ID="btnPay" Text="Pay" CssClass="btn btn-primary w-100" OnClick="btnPay_Click" />
                </div>
            </div>
        </div>
    </main>
</asp:Content>
