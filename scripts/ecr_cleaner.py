import boto3
import sys

# --- CONFIGURATION ---
REPO_NAME = "your-fargate-repo-name" 
IMAGES_TO_KEEP = 5
# ---------------------

def clean_ecr():
    try:
        # Initialize the ECR client
        ecr = boto3.client('ecr')

        # 1. Get all images in the repo
        response = ecr.describe_images(repositoryName=REPO_NAME)
        images = response['imageDetails']

        # 2. Sort them by push date (newest first)
        images.sort(key=lambda x: x['imagePushedAt'], reverse=True)

        # 3. Identify old images to delete
        old_images = images[IMAGES_TO_KEEP:]
        
        if not old_images:
            print("✅ Nothing to clean. Image count is within limits.")
            return

        # 4. Extract the digests (unique IDs)
        digests = [{'imageDigest': img['imageDigest']} for img in old_images]

        # 5. Delete them
        ecr.batch_delete_image(repositoryName=REPO_NAME, imageIds=digests)
        print(f"🚀 Successfully deleted {len(digests)} old images.")

    except ecr.exceptions.RepositoryNotFoundException:
        print(f"❌ ERROR: Repository '{REPO_NAME}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"❌ UNEXPECTED ERROR: {e}")
        sys.exit(1)

if __name__ == "__main__":
    clean_ecr()