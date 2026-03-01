using Microsoft.AspNetCore.Mvc;
using OrdersApi.Models;

namespace OrdersApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private static readonly Random _random = new();

    [HttpPost]
    public IActionResult CreateOrder([FromBody] OrderRequest request)
    {
        // Простейшая валидация
        if (request.UserId <= 0 || request.ServiceId <= 0)
        {
            return BadRequest(new { message = "UserId and ServiceId must be positive integers" });
        }

        // Имитация создания заказа
        var response = new OrderResponse
        {
            OrderId = _random.Next(1000, 9999),
            Status = "created",
            PaymentUrl = _random.Next(0, 2) == 0 ? null : $"https://oplataoreder.com/{Guid.NewGuid()}"
        };

        return Ok(response);
    }
}