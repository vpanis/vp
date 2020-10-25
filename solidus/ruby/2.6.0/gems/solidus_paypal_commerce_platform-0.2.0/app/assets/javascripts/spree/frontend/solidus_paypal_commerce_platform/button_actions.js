SolidusPaypalCommercePlatform.showOverlay = function() {
  document.getElementById("paypal_commerce_platform_overlay").style.display = "block";
}

SolidusPaypalCommercePlatform.hideOverlay = function() {
  document.getElementById("paypal_commerce_platform_overlay").style.display = "none";
}

SolidusPaypalCommercePlatform.handleError = function(error) {
  console.log(error.name, error.message)
  console.log("PayPal Debug ID: " + error.debug_id)
  alert("There was a problem connecting with PayPal.")
}

SolidusPaypalCommercePlatform.sendOrder = function(payment_method_id) {
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/paypal_orders/' + Spree.current_order_id,
    method: 'GET',
    data: {
      payment_method_id: payment_method_id,
      order_token: Spree.current_order_token
    }
  }).then(function(success_response) {
    return success_response.table.result.table.id
  }, function(failure_response) {
    return failure_response.responseJSON.table.error.table
  })
}

SolidusPaypalCommercePlatform.createAndSendOrder = function(payment_method_id) {
  return SolidusPaypalCommercePlatform.createOrder().then(function(){
    return SolidusPaypalCommercePlatform.sendOrder(payment_method_id)
  })
}

SolidusPaypalCommercePlatform.createOrder = function() {
  var data = {
    order: {
      line_items_attributes: [{
        variant_id: SolidusPaypalCommercePlatform.getVariantId(),
        quantity: SolidusPaypalCommercePlatform.getQuantity()
      }]
    }
  }

  return Spree.ajax({
    url: "/solidus_paypal_commerce_platform/orders",
    method: 'POST',
    data: data,
    error: function(response) {
      message = response.responseJSON
      alert('A problem has occurred while creating your order - ' + message);
    }
  }).then(function(response) {
    Spree.current_order_id = response.number
    Spree.current_order_token = response.guest_token
  });
}

SolidusPaypalCommercePlatform.getVariantId = function() {
  var variants = document.getElementsByName("variant_id")
  var variant_id;
  if(variants.length == 1){
    variant_id = variants[0].value
  }else{
    var i;
    for (i = 0; i < variants.length; i++) {
      if (variants[i].checked) {
        variant_id = variants[i].value
      }
    }
  }
  return variant_id
}

SolidusPaypalCommercePlatform.getQuantity = function() {
  return document.getElementById("quantity").value
}

SolidusPaypalCommercePlatform.approveOrder = function(data, actions) {
  SolidusPaypalCommercePlatform.showOverlay()
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      SolidusPaypalCommercePlatform.verifyTotal(response.purchase_units[0].amount.value).then(function(){
        $("#payments_source_paypal_order_id").val(data.orderID)
        $("#payments_source_paypal_email").val(response.payer.email_address)
        $("#checkout_form_payment").submit()
      })
    })
  })
}

SolidusPaypalCommercePlatform.shippingChange = function(data, actions) {
  Spree.ajax({
    url: '/solidus_paypal_commerce_platform/shipping_rates',
    method: 'GET',
    data: {
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token,
      address: data.shipping_address
    },
    error: function(response) {
      message = response.responseJSON;
      console.log('There were some problems with your payment address - ' + message);
      actions.reject()
    }
  }).then(function(response) {
    actions.order.patch([response]).catch(function() {
      actions.reject()
    })
  })
}

SolidusPaypalCommercePlatform.verifyTotal = function(paypal_total) {
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/verify_total',
    method: 'GET',
    data: {
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token,
      paypal_total: paypal_total
    },
    error: function(response) {
      SolidusPaypalCommercePlatform.hideOverlay()
      alert('There were some problems with your payment - ' + response.responseJSON.errors.expected_total);
    }
  })
}

SolidusPaypalCommercePlatform.finalizeOrder = function(payment_method_id, data, actions) {
  SolidusPaypalCommercePlatform.showOverlay()
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      var paypal_amount = response.purchase_units[0].amount.value
      SolidusPaypalCommercePlatform.advanceOrder().then(function() {
        SolidusPaypalCommercePlatform.verifyTotal(paypal_amount).then(function(){
          SolidusPaypalCommercePlatform.addPayment(paypal_amount, payment_method_id, data, response.payer.email_address).then(function() {
            window.location.href = SolidusPaypalCommercePlatform.checkout_url
          })
        })
      })
    })
  })
}

SolidusPaypalCommercePlatform.advanceOrder = function() {
  return Spree.ajax({
    url: '/api/checkouts/' + Spree.current_order_id + '/advance',
    method: 'PUT',
    data: {
      order_token: Spree.current_order_token
    },
    error: function(response) {
      SolidusPaypalCommercePlatform.hideOverlay()
      alert('There were some problems with your order');
    }
  })
}

SolidusPaypalCommercePlatform.addPayment = function(paypal_amount, payment_method_id, data, email) {
  return Spree.ajax({
    url: '/api/checkouts/' + Spree.current_order_id + '/payments',
    method: 'POST',
    data: {
      order_token: Spree.current_order_token,
      payment: {
        amount: paypal_amount,
        payment_method_id: payment_method_id,
        source_attributes: {
          paypal_order_id: data.orderID,
          paypal_email: email
        }
      }
    },
    error: function(response) {
      SolidusPaypalCommercePlatform.hideOverlay()
      alert('There were some problems with your payment');
    }
  })
}

SolidusPaypalCommercePlatform.updateAddress = function(response) { 
  var updated_address = response.purchase_units[0].shipping.address
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/update_address',
    method: 'POST',
    data: {
      address: {
        updated_address: updated_address,
        recipient: response.payer
      },
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token
    },
    error: function(response) {
      SolidusPaypalCommercePlatform.hideOverlay()
      message = response.responseJSON;
      alert('There were some problems with your payment address - ' + message);
    }
  })
}
