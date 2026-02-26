<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MWM_Assignment._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <%--Carousel--%>
        <div id="mainCarousel" class="carousel slide mb-5 carousel-size" data-bs-ride="carousel">
            <div class="carousel-inner">
                <asp:ListView runat="server" ID="lvCarousel">
                    <ItemTemplate>
                        <div class="carousel-item <%# getActiveClass(Container.DisplayIndex) %>" style="background: black;">
                            <img src='<%# Eval("image") %>' class="d-block w-100 main-carousel-image" runat="server" alt='<%# Eval("name") %>'>
                            <div class="carousel-caption d-none d-md-block">
                                <h3><%# Eval("name") %></h3>
                                <p><%# Eval("description") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div>

            <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <%--Categories--%>
        <div class="container mb-5">
            <div class="row">
                <h3 class="text-secondary">CATEGORIES</h3>
            </div>
            <hr />
            <div class="row">
                <asp:ListView ID="lvCategories" runat="server" OnItemCommand="lvCategories_ItemCommand">
                    <ItemTemplate>
                        <div class="col-lg-3 col-6">
                            <a href="ProductCatalog.aspx?cid=<%# Eval("cid") %>">
                                <div class="card m-1 bg-white cards">
                                    <img src='<%# Eval("image") %>' runat="server" class="card-img category-image-fit" alt='<%# Eval("name") %>'>
                                    <div class="card-img-overlay">
                                        <h5 class="card-title card-text-shadow"><%# Eval("name") %></h5>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>

        <%--Best Sellers--%>
        <div class="container mb-5">
            <div class="row">
                <h3 class="text-secondary">BEST SELLERS</h3>
            </div>
            <hr />
            <div class="row">
                <asp:ListView ID="lvTopProducts" runat="server" OnItemCommand="lvCategories_ItemCommand">
                    <ItemTemplate>
                        <div class="col-lg-3 col-6">
                            <a href="ProductDetails.aspx?pid=<%# Eval("pid") %>">
                                <div class="card m-1 bg-white cards">
                                    <img runat="server" src='<%# Eval("image") %>' class="card-img category-image-fit" alt='<%# Eval("name") %>'>
                                    <div class="card-img-overlay d-flex flex-column justify-content-between align-items-start">
                                        <h5 class="card-title"><%# Eval("name") %></h5>
                                        <div class="row">
                                            <div class="col">
                                                <p class="card-text small "><%# Eval("price", "{0:C}") %></p>
                                            </div>
                                            <div class="col">
                                                <p class="card-text small"><%# Eval("qtysold").ToString() + " sold" %></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>
    </main>

</asp:Content>
