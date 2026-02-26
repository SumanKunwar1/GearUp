<%@ Page Title="Product Details Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="MWM_Assignment.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container" style="min-height: 60vh;">
        <div class="row g-0 mt-5 mb-2">
            <h3 class="text-secondary">PRODUCT DETAILS</h3>
            <hr />
        </div>
        <div class="mb-3">
            <a href='javascript:history.go(-1)' class="text-decoration-none">< Go Back to Previous Page</a>
        </div>
        <div class="bg-white p-5 mb-3 shadow-sm">
            <div class="row justify-content-center">
                <div class="col-12 col-md-5 px-5">
                    <div class="row">
                        <h3 class="text-secondary">PRODUCT</h3>
                        <hr />
                        <div>
                            <asp:Image CssClass="img-fluid rounded" runat="server" ID="img_Image" ImageUrl="https://placehold.co/600x400" Style="height: 200px; width: 100%; object-fit: contain" />
                        </div>
                        <div>
                            <asp:Label runat="server" ID="lblName" Text="Placeholder" CssClass="fw-bold h5" />
                        </div>
                        <div class="my-2">
                            <asp:Label runat="server" ID="lblPrice" Text="Placeholder" CssClass="text-danger py-3"></asp:Label>
                        </div>
                        <div class="my-2">
                            <span class="ratingStar">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <asp:Label runat="server" ID="lblAvgRating" CssClass="ratingNum"></asp:Label>
                                <span>/ 5</span>
                            </span>
                        </div>
                        <div>
                            <asp:Label runat="server" ID="lblQuantity" AssociatedControlID="txt_Quantity" Text="Quantity" CssClass="form-text" />
                            <asp:TextBox CssClass="form-control" runat="server" Text="1" TextMode="Number" ID="txt_Quantity" min="1"></asp:TextBox>
                            <div class="btn-group my-3" role="group">
                                <asp:Button runat="server" ID="btnAddCart" CssClass="btn btn-outline-primary " Text="Add To Cart" OnClick="btnAddCart_Click" />
                                <asp:Button runat="server" ID="btnGoCart" CssClass="btn btn-primary" Text="Buy Now" OnClick="btnGoCart_Click" />
                            </div>
                        </div>

                    </div>
                 </div>
                <div class="col-12 col-md px-5">
                    <div class="row">
                        <h3 class="text-secondary">DESCRIPTION</h3>
                        <hr />
                        <asp:Label runat="server" ID="lblDescription" Text="Placeholder" Style="white-space: pre-wrap;" />
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white p-5 shadow-sm">
            <div class="row">
                <h3 class="text-secondary">REVIEWS</h3>
                <hr />
            </div>
            <asp:DataList ID="dlReview" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                <ItemTemplate>
                    <div class="row bg-light p-3">
                        <div class="row align-items-center py-2">
                            <div class="col-auto">
                                <img src='<%# Eval("image") %>' runat="server" alt="profile picture" class="profile-image-nav" />
                            </div>
                            <div class="col">
                                <div class="row justify-content-between">
                                    <div class="col">
                                        <label class="text-secondary"><%# Eval("custName") %></label>
                                    </div>
                                    <div class="col text-end">
                                        <label class="text-secondary small"><%# Eval("dtAdded") %></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <span class="ratingStar">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <span class="ratingNum"><%# Eval("Rating") %></span>
                                <span>/ 5</span>
                            </span>
                            <label><%# Eval("description") %></label>
                        </div>
                    </div>
                    <hr />
                </ItemTemplate>
                <FooterTemplate>
                    <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlReview.Items.Count != 0) ? "d-none" : ""%>">
                        <img src="~/Images/Placeholder/noData.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                        <p>No reviews for this product!</p>
                    </div>
                </FooterTemplate>
            </asp:DataList>
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
    </main>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
    <script>

        function setRating() {

            const ratingStars = document.querySelectorAll(".ratingStar");
            ratingStars.forEach(ratingStar => {
                const ratingNumSpan = ratingStar.querySelector(".ratingNum");
                const ratingValue = parseFloat(ratingNumSpan.textContent);

                // Fill Stars Based on Rating:
                const stars = ratingStar.querySelectorAll("i.bi-star-fill");

                for (i = 0; i < stars.length; i++) {
                    stars[i].classList.toggle("text-warning", i < ratingValue);

                }

                console.log(ratingValue)
                console.log(Math.floor(ratingValue))
                console.log(stars[Math.floor(ratingValue)])

                console.log(ratingValue > stars[Math.floor(ratingValue)])

                if (ratingValue - Math.floor(ratingValue) > 0) {
                    stars[Math.floor(ratingValue)].classList = "bi bi-star-half text-warning"
                }
            });
        }


        document.addEventListener("DOMContentLoaded", setRating());
    </script>
</asp:Content>
