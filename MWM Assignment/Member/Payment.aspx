<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="MWM_Assignment.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container" style="height: 80vh">
        <div class="card bg-white">
            <div class="card-body">
                <div class="row text-center mt-2 mb-5">
                    <h3 class="fw-bold">Payment Successful</h3>
                </div>
                <div class="row g-0 justify-content-center align-content-center">
                    <div class="col-12 col-md-6 text-center">
                        <img src="/Images/Placeholder/circle_green_checkmark.svg" style="height: 10rem; width: 10rem">
                    </div>
                    <hr class=" my-3 d-md-none" />
                    <div class="col-12 col-md-6">
                        <div class="row g-0 justify-content-between align-content-center">
                            <div class="col">
                                <span class="text-secondary">Order Reference: </span>
                            </div>
                            <div class="col">
                                <asp:Label runat="server" ID="lblOrderRef" Text="" />
                            </div>
                        </div>
                        <hr />
                        <div class="row g-0 justify-content-between">
                            <div class="col">
                                <span class="text-secondary">Payment Total: </span>
                            </div>
                            <div class="col">
                                <asp:Label runat="server" ID="lblTotal" Text="" />
                            </div>
                        </div>
                        <hr />
                        <div class="row g-0 justify-content-between">
                            <div class="col">
                                <span class="text-secondary">Completed Time: </span>
                            </div>
                            <div class="col">
                                <asp:Label runat="server" ID="lblTimestamp" Text="" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-5 mb-2 justify-content-center">
                    <a href="../Default.aspx" class="btn btn-primary" style="width: 18rem;">Back to Main Page</a>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
