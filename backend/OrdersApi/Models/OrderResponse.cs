namespace OrdersApi.Models;

public class OrderResponse
{
    public int OrderId { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? PaymentUrl { get; set; }
}