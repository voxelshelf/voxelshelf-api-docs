const baseUrl = process.env.BASE_URL ?? "https://api.voxelshelf.com/api";
const apiKey = process.env.VOXELSHELF_API_KEY;
const uploadId = process.env.UPLOAD_ID ?? "upl_replace_me";
const fileStorageKey = process.env.ASSET_STORAGE_KEY ?? "uploads/demo/model.zip";

if (!apiKey) {
  console.error("Missing VOXELSHELF_API_KEY");
  process.exit(1);
}

async function run() {
  const completeUploadResponse = await fetch(`${baseUrl}/v1/uploads/complete`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "X-Request-Id": "req_node_upload_complete_001",
      "Idempotency-Key": "idem-node-upload-complete-001",
    },
    body: JSON.stringify({ uploadId }),
  });

  if (!completeUploadResponse.ok) {
    const body = await completeUploadResponse.text();
    throw new Error(`complete failed (${completeUploadResponse.status}): ${body}`);
  }

  const createProductResponse = await fetch(`${baseUrl}/v1/creator/products`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "X-Request-Id": "req_node_product_create_001",
      "Idempotency-Key": "idem-node-product-create-001",
    },
    body: JSON.stringify({
      title: "Node Example Product",
      description: "Created from Node API example.",
      category: "Home & Decor",
      subcategory: "Decor & Lighting",
      printMaterials: ["PLA"],
      supports: "Optional",
      difficulty: "Easy",
      isPresupported: false,
      license: "Personal",
      price: 12,
      images: [{ url: "https://images.voxelshelf.com/demo-node.jpg", alt: "Node demo" }],
      files: [
        {
          storageKey: fileStorageKey,
          filename: "model.zip",
          size: 1234567,
          mime: "application/zip",
          kind: "Archive",
        },
      ],
    }),
  });

  if (!createProductResponse.ok) {
    const body = await createProductResponse.text();
    throw new Error(`create product failed (${createProductResponse.status}): ${body}`);
  }

  const draft = await createProductResponse.json();
  const productId = draft?.id;
  if (!productId) {
    throw new Error("create product response did not include id");
  }

  const publishResponse = await fetch(`${baseUrl}/v1/creator/products/${productId}/publish`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "X-Request-Id": "req_node_product_publish_001",
      "Idempotency-Key": "idem-node-product-publish-001",
    },
  });

  if (!publishResponse.ok) {
    const body = await publishResponse.text();
    throw new Error(`publish failed (${publishResponse.status}): ${body}`);
  }

  const published = await publishResponse.json();
  console.log("Published product:", published);
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});
